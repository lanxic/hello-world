from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
	current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f'Hello World from CMI X series in {current_date}'

# main driver function
if __name__ == '__main__':

	app.run(debug=True, host="0.0.0.0", port=80)
