class Empleado():
    def __init__(self, id_login, username, password_hash=None):
        self.id_login = id_login
        self.username = username
        self.password_hash = password_hash
