from sqlalchemy import text
from models.entities.userEmpleado import Empleado
from models.entities.empleado import Empleados
from werkzeug.security import generate_password_hash


class ModelUser:

    # *** VERIFICACION DE USUARIO CON PROCEDIMIENTO ALMACENADO ***
    @classmethod
    def login(self, db, username, password):
        try:
            # Llamar a la función verificar_usuario_password
            query = text("SELECT verificar_usuario_password(:username, :password)")
            result = db.session.execute(query, {"username": username, "password": password}).fetchone()

            # Verificar si el usuario fue encontrado (la función devuelve el id_login)
            if result and result[0] is not None:
                id_login = result[0]
                return id_login  # Retornar id_login si las credenciales son correctas
            else:
                return None  # Credenciales incorrectas
        except Exception as ex:
            raise Exception(ex)

    # *** GUARDA USUARIO CON PROCEDIMIENTO ALMACENADO ***
    @classmethod
    def registrar_usuario(self, db, user):
        try:
            # Guardar el usuario en la tabla login_empleados
            query = text("""
                INSERT INTO login_empleados (username, password_hash)
                VALUES (:username, :password_hash)
                RETURNING id_login
            """)
            result = db.session.execute(query, {
                "username": user.username,
                "password_hash": user.password_hash
            }).fetchone()

            # Asociar id_login al empleado si es necesario
            if result and result[0]:
                db.session.commit()
                return result[0]
            else:
                raise Exception("Error al registrar el usuario.")
        except Exception as ex:
            db.session.rollback()  # Deshacer cambios en caso de error
            raise Exception(ex)
            
    @classmethod
    def update_password(self, db, id_login, new_password):
        try:
            new_password_hash = generate_password_hash(new_password)
            query = text("""
                UPDATE login_empleados
                SET password_hash = :new_password_hash
                WHERE id_login = :id_login
            """)
            db.session.execute(query, {"new_password_hash": new_password_hash, "id_login": id_login})
            db.session.commit()
            return True
        except Exception as ex:
            db.session.rollback()
            raise Exception(f"Error al actualizar la contraseña: {str(ex)}")
        
    @classmethod
    def agregar_empleado(self, db, empleado):
        try:
            query = text("""
                INSERT INTO empleados (nombre, apellido, cedula, telefono)
                VALUES (:nombre, :apellido, :cedula, :telefono)
                RETURNING id_empleado
            """)
            print(empleado.apellido, 'hola')
            result = db.session.execute(query, {
                "nombre": empleado.nombre,
                "apellido": empleado.apellido,
                "cedula": empleado.cedula,
                "telefono": empleado.telefono
            }).fetchone()

            if result and result[0]:
                db.session.commit()
                return result[0]  # Retorna el ID del nuevo empleado
            else:
                raise Exception("Error al registrar la información del empleado.")
        except Exception as ex:
            db.session.rollback()
            raise Exception(f"Error al registrar la información del empleado: {str(ex)}")
