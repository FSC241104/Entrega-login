# models/entities/empleado.py

class Empleados:
    def __init__(self, id_empleado=None, nombre=None, apellido=None, cedula=None, telefono=None, id_login=None):
        self.id_empleado = id_empleado
        self.nombre = nombre
        self.apellido = apellido
        self.cedula = cedula
        self.telefono = telefono
        self.id_login = id_login

    def __repr__(self):
        return f'<Empleado {self.nombre} {self.apellido}>'
