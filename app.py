from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
	return 'Hello World from AWS-EKS test1'

# main driver function
if __name__ == '__main__':

	app.run(debug=True, host="0.0.0.0", port=80)
