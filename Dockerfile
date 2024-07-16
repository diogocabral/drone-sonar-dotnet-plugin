FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN dotnet tool install --global dotnet-sonarscanner --version 6.2.0

ENV PATH="/root/.dotnet/tools:${PATH}"

ARG SONAR_VERSION=4.5.0.2216
ARG SONAR_SCANNER_CLI=sonar-scanner-cli-${SONAR_VERSION}
ARG SONAR_SCANNER=sonar-scanner-${SONAR_VERSION}

RUN apt-get update \
    && apt-get install -y unzip default-jre \
    && apt-get clean

WORKDIR /bin

RUN curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_CLI}.zip -so /bin/${SONAR_SCANNER_CLI}.zip
RUN unzip ${SONAR_SCANNER_CLI}.zip\
    && rm ${SONAR_SCANNER_CLI}.zip

ENV PATH $PATH:/bin/${SONAR_SCANNER}/bin

COPY drone-sonar.sh .
RUN chmod +x drone-sonar.sh

CMD /bin/drone-sonar.sh
