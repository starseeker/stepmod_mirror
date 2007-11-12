import java.util.Enumeration;
import java.util.Hashtable;

public class MetadataCollection {
    Hashtable<String,Metadata> theMetadata;

    public MetadataCollection() {
	theMetadata = new Hashtable<String,Metadata>();
    }

    public void put(String k, Metadata v) {
	theMetadata.put(k, v);
    }

    public Metadata get(String k) {
	return theMetadata.get(k);
    }

    public void print() {
	Enumeration<String> keyEnum = theMetadata.keys();
	while (keyEnum.hasMoreElements()) {
	    Metadata metadata = theMetadata.get(keyEnum.nextElement());
	    metadata.print();
	}
    }
}
