FROM akkk/kurento-media-server:dev-env-20231120
LABEL MAINTAINER=tplinknbu<nbucloud.ops@tp-link.com.cn>

ENV LANG="C.UTF-8"

COPY repository/ /root/.m2/repository

# Copy code into docker
COPY gst-plugins-good/ /gst-plugins-good/

# Build
RUN cd gst-plugins-good \
  && chmod +x ./autogen.sh \
  && ./autogen.sh \
  && make \
  && cp gst/rtpmanager/.libs/libgstrtpmanager.so /usr/lib/x86_64-linux-gnu/gstreamer-1.5/ \
  && cp gst/rtp/.libs/libgstrtp.so /usr/lib/x86_64-linux-gnu/gstreamer-1.5/

# Copy code into docker
COPY kms-omni-build/ /kms-omni-build/

# Build (remove run-part from .sh line-462)
RUN export MAKEFLAGS="-j$(nproc)" \
 && cd kms-omni-build \
 && chmod +x ./bin/kms-build-run.sh \
 && ./bin/kms-build-run.sh

# Expose default Kurento RPC control port.
EXPOSE 8888

# scripts are from https://github.com/Kurento/kurento/blob/main/docker/kurento-media-server
# modify the start command in entrypoint.sh
COPY scripts /
RUN chmod +x /healthchecker.sh \
 && chmod +x /entrypoint.sh \
 && chmod +x /getmyip.sh

HEALTHCHECK --start-period=15s --interval=30s --timeout=3s --retries=1 CMD /healthchecker.sh

ENTRYPOINT ["/entrypoint.sh"]
