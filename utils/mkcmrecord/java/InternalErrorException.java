public class InternalErrorException extends Exception {
    public InternalErrorException(String msg) {
	super(msg);
    }
    public InternalErrorException(Exception e) {
	super(e);
    }
}
