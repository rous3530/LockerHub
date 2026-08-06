package mx.edu.utez.locker.model;

public class Alumno {
    private int idAlumno;
    private String matricula;
    private String nombres;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String correo;
    private String contrasena;
    private String idCarrera;
    private String rol;

    public Alumno() {}

    public Alumno(String matricula, String nombres, String apellidoPaterno, String apellidoMaterno, String correo, String contrasena, String idCarrera, String rol) {
        this.matricula = matricula;
        this.nombres = nombres;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.correo = correo;
        this.contrasena = contrasena;
        this.idCarrera = idCarrera;
        this.rol = rol;
    }

    // Getters y Setters
    public int getIdAlumno() { return idAlumno; }
    public void setIdAlumno(int idAlumno) { this.idAlumno = idAlumno; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidoPaterno() { return apellidoPaterno; }
    public void setApellidoPaterno(String apellidoPaterno) { this.apellidoPaterno = apellidoPaterno; }

    public String getApellidoMaterno() { return apellidoMaterno; }
    public void setApellidoMaterno(String apellidoMaterno) { this.apellidoMaterno = apellidoMaterno; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }

    public String getIdCarrera() { return idCarrera; }
    public void setIdCarrera(String idCarrera) { this.idCarrera = idCarrera; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
}