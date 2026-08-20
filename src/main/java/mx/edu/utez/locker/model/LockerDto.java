package mx.edu.utez.locker.model;

public class LockerDto {
    private String idLocker;
    private String numeroLocker;
    private String piso;
    private String estatus;
    private int idEdificio;

    // Constructor vacio
    public LockerDto() {
    }

    // Constructor con parámetros principales
    public LockerDto(String idLocker, String numeroLocker, String piso, String estatus, int idEdificio) {
        this.idLocker = idLocker;
        this.numeroLocker = numeroLocker;
        this.piso = piso;
        this.estatus = estatus;
        this.idEdificio = idEdificio;
    }

    // Getters y Setters
    public String getIdLocker() {
        return idLocker;
    }

    public void setIdLocker(String idLocker) {
        this.idLocker = idLocker;
    }

    public String getNumeroLocker() {
        return numeroLocker;
    }

    public void setNumeroLocker(String numeroLocker) {
        this.numeroLocker = numeroLocker;
    }

    public String getPiso() {
        return piso;
    }

    public void setPiso(String piso) {
        this.piso = piso;
    }

    public String getEstatus() {
        return estatus;
    }

    public void setEstatus(String estatus) {
        this.estatus = estatus;
    }

    public int getIdEdificio() {
        return idEdificio;
    }

    public void setIdEdificio(int idEdificio) {
        this.idEdificio = idEdificio;
    }
}