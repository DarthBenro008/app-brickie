FROM openjdk:11

RUN apt-get update
RUN apt-get -y install curl unzip openssl
ARG ANDROID_SDK_VERSION=7583922
ENV ANDROID_SDK_ROOT /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
          wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
              unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
                  rm *tools*linux*.zip
COPY license_accepter.sh /opt/
RUN chmod +x /opt/license_accepter.sh && /opt/license_accepter.sh $ANDROID_SDK_ROOT
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD flutter.sh /flutter.sh 
RUN chmod +x /flutter.sh
ENV ANDROID_HOME="${ANDROID_SDK_ROOT}"
RUN chmod +x $ANDROID_HOME/*
ENTRYPOINT ["/entrypoint.sh"]
