from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash
from config import Config
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from models.entities.empleado import Empleados
from models.modelUser import ModelUser
from models.entities.userEmpleado import Empleado
from werkzeug.security import check_password_hash, generate_password_hash


# he estado enbalado con el trabajo de juan camilo #

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)


# Ruta para la página principal
@app.route('/')
def home():
        return render_template("home.html")

# Ruta para la página "About"
@app.route('/about')
def about():
        return render_template("about.html")

# Ruta para el inicio de sesión
@app.route('/login', methods=['GET', 'POST'])
def login():
        if request.method == 'POST':
                username = request.form['username']
                password = request.form['password']

                try:
                        # Verificar usuario y contraseña llamando al método de ModelUser
                        id_login = ModelUser.entities.login(db, username, password)

                        if id_login:
                                # Si las credenciales son correctas, redirigir al home
                                session['user_id'] = id_login
                                flash('Inicio de sesión exitoso', 'success')
                                return redirect(url_for('cambiar_password'))
                        else:
                                flash('Usuario o contraseña incorrectos', 'error')
                except Exception as e:
                        flash(f'Error en el inicio de sesión: {str(e)}', 'error')
        return render_template('login.html')

# Ruta para registrarse
@app.route('/singin', methods=['GET', 'POST'])
def singin():
        if request.method == 'POST':
                # Obtener datos del formulario
                username = request.form.get('username')
                password = request.form.get('password')
                confirm_password = request.form.get('confirmPassword')
                

                # Verificar que las contraseñas coincidan
                if password != confirm_password:
                        flash('Las contraseñas no coinciden.', 'error')
                        return render_template("singin.html")

                # Hashear la contraseña
                hashed_password = generate_password_hash(password)

                # Crear una instancia del modelo Empleado (o puedes crear un modelo solo para Login)
                user = Empleado(id_login=None, username=username, password_hash=hashed_password)

                try:
                        # Guardar usuario en la base de datos usando el método de la clase ModelUser
                        ModelUser.registrar_usuario(db, user)
                        flash('Usuario registrado exitosamente.', 'success')
                        return render_template('empleado.html')
                except Exception as e:
                        flash(f'Error al registrar el usuario: {str(e)}', 'error')
                        return redirect(url_for('singin'))
        return render_template('singin.html')


# Ruta para crear un empleado
@app.route('/empleado', methods=['GET', 'POST'])
def empleado():
        if request.method == 'POST':
                nombre = request.form['nombre']
                apellido = request.form['apellido']
                cedula = request.form['cedula']
                telefono = request.form['telefono']
                id_login = session.get('user_id')  # Esto asume que el usuario está logueado y el id_login está en la sesión
                
                # Verificar que el usuario esté autenticado
                

                # Crear una instancia de Empleados con los datos proporcionados
                empleado = Empleados(
                        nombre=nombre,
                        apellido=apellido,
                        cedula=cedula,
                        telefono=telefono,
                        id_login=id_login
                        )
                print(id_login)
                try:
                        # Llamar al método para agregar el empleado en la base de datos
                        empleado_id = ModelUser.agregar_empleado(db, empleado)
                        flash(f'Empleado registrado exitosamente con ID {empleado_id}.', 'success')
                        return redirect(url_for('empleado'))
                except Exception as e:
                        flash(f'Error al registrar el empleado: {str(e)}', 'error')
                        return redirect(url_for('empleado'))
        # Si la solicitud es GET, renderiza el formulario de registro de empleados
        return render_template('login.html')

# Ruta para modificar la contraseña del usuario autenticado
@app.route('/cambiar_password', methods=['GET', 'POST'])
def cambiar_password():
        if request.method == 'POST':
                username = request.form['username']
                new_password = request.form['new_password']
                confirm_password = request.form['confirm_password']

                # Verificar que la nueva contraseña coincide con la confirmación
                if new_password != confirm_password:
                        flash('Las contraseñas no coinciden.', 'error')
                        return redirect(url_for('cambiar_password'))

                try:
                        # Buscar el usuario por su nombre de usuario
                        query = text("SELECT id_login FROM login_empleados WHERE username = :username")
                        result = db.session.execute(query, {"username": username}).fetchone()

                        # Verificar si el usuario existe
                        if result:
                                user_id = result[0]
                                # Actualizar la contraseña
                                ModelUser.update_password(db, user_id, new_password)
                                flash('Contraseña actualizada exitosamente.', 'success')
                                return redirect(url_for('login'))
                        else:
                                flash('Usuario no encontrado.', 'error')
                except Exception as e:
                        flash(f'Error al actualizar la contraseña: {str(e)}', 'error')
        return render_template('login.html')


# Ruta para el catálogo
@app.route('/catalogo')
def catalogo():
        return render_template("catalogo.html")

# Ruta para la página de contacto
@app.route('/contacto')
def contacto():
        return render_template("contacto.html")

if __name__ == "__main__":
        app.run(debug=True)
