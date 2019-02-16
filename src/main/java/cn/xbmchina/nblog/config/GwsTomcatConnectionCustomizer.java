package cn.xbmchina.nblog.config;

import org.apache.catalina.connector.Connector;
import org.springframework.boot.web.embedded.tomcat.TomcatConnectorCustomizer;

public class GwsTomcatConnectionCustomizer  implements TomcatConnectorCustomizer {

    public GwsTomcatConnectionCustomizer() {
    }

    @Override
    public void customize(Connector connector) { }
}
