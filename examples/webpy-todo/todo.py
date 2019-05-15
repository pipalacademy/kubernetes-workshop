import web
import os

urls = (
    "/", "index",
    "/healthy", "healthy",
    "/ready", "ready"
)

READY = False

app = web.application(urls, globals())
render = web.template.render("templates/")

db_url = os.getenv("DATABASE_URL")
db = web.database(db_url)

READY=True

def get_todos():
    return db.select("todo", order="id desc")

def add_todo(todo):
    db.insert("todo", label=todo)

class index:
    def GET(self):
        todos = get_todos()
        return render.index(todos)

    def POST(self):
        i = web.input(todo="")
        if i.todo:
            add_todo(i.todo)
        raise web.seeother("/")

class healthy:
    def GET(self):
        try:
            db.query('select 1;')
            web.ctx.status = '200 OK'
        except:
            web.ctx.status = '500 Internal Server Error'

class ready:
    def GET(self):
        global READY
        if READY:
            web.ctx.status = '200 OK'
        else:
            web.ctx.status = '500 Internal Server Error'


if __name__ == "__main__":
    app.run()
