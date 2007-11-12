public interface CvsOutputProcessor {
    void init();
    void putLine(String line);
    void flush();
}
