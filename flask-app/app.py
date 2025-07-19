from flask import Flask

app = Flask(__name__)
HOST = '0.0.0.0'
PORT = 5000

@app.route("/")
def hello_world():
    return "Hello World from Python!"

if __name__ == "__main__":
    app.run(host=HOST, port=PORT)