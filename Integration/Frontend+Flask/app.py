from flask import Flask, render_template, request, redirect, url_for
from cs50 import SQL

app = Flask(__name__)
db = SQL("postgresql://postgres:pgadmin@localhost:5432/Project")

class Students:
    def __init__(self, student_id):
        self.student_id = student_id

@app.route("/")
def home():
    return render_template("login.html")



@app.route("/login", methods = ["POST"])
def login():
    email = request.form.get("email")
    password = request.form.get("password")

    user = db.execute("SELECT * FROM student_login WHERE student_email= ? AND student_password = ?;", email, password)
    
    if user:
        std_id = db.execute("SELECT * FROM students WHERE student_email = ?;", email)
        if std_id:
            student = Students(std_id[0]['student_id'])
        return redirect(url_for('index', std = student.student_id))
    else:
        return redirect('/')

@app.route("/index/<std>")
def index(std):
     std = db.execute("SELECT * FROM students WHERE student_id = ?;", std)
     std = Students(std[0]['student_id'])
     print("std_id:", std)
     return render_template("index.html", std_id = std)

if __name__ == '__main__':
    app.run(debug=True)