from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello, AWS Docker EKS DevOps PoC!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
