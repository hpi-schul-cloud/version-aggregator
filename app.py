import json
import os
import re
import urllib.request
from http.server import HTTPServer, BaseHTTPRequestHandler
import logging
from urllib.error import URLError

logging.basicConfig(level=logging.DEBUG)
services = {}


class WebServer(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == '/version':
            result = {}
            encountered_issues = False
            for service in services:
                static_version, _value = services[service]
                if static_version:
                    result[service] = _value
                else:
                    service_url = _value
                    logging.info('calling for client ' + service + ': ' + service_url)
                    request = urllib.request.Request(service_url)
                    try:
                        with urllib.request.urlopen(request) as response:
                            data = json.loads(response.read().decode('UTF-8'))
                            result[service] = data
                    except URLError:
                        logging.error('service not available ' + service_url, exc_info=True)
                        encountered_issues = True
                        result[service] = 'unavailable'

            result['services-unavailable'] = encountered_issues
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(result, sort_keys=True, indent=4).encode(encoding='UTF-8'))
        else:
            self.send_response(404)
            self.end_headers()


for key, value in os.environ.items():
    if key.startswith('version.'):
        re_static_result = re.search(r"(\bversion\.\b)(\b.+\b)\.static", key)
        re_url_result = re.search(r"(\bversion\.\b)(\b.+\b)\.url", key)
        if re_static_result is not None:
            services[re_static_result.group(2)] = (True, value)
        elif re_url_result is not None:
            services[re_url_result.group(2)] = (False, value)
        else:
            logging.error("config is neither static nor an url: " + key)


httpd = HTTPServer(('0.0.0.0', 8080), WebServer)
httpd.serve_forever()
