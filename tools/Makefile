all:
		mvn eclipse:eclipse -Dwtpversion=2.0 -DdownloadSources=true -DdownloadJavadocs=true
run:
	MAVEN_OPTS="-Xms4g -Xmx6g" mvn clean -Plocal jetty:run

dup:
		mvn enforcer:enforce

dep:
	    mvn dependency:tree -Ddetail

clean:
	mvn clean
	rm ./version.properties
	rm ./dict.dat
