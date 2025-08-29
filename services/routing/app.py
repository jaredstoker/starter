from flask import Flask, request, jsonify
import os
app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({ 'status': 'ok' })

@app.route('/ingest', methods=['POST'])
def ingest():
    payload = request.get_json() or {}
    # TODO: normalize -> push to SQS -> return assignment
    return jsonify({ 'received': True, 'payload_sample': payload }), 202

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
