FROM akkk/kurento-media-server:dev-env-20231120
LABEL MAINTAINER=tplinknbu<nbucloud.ops@tp-link.com.cn>

ENV LANG="C.UTF-8"

# Copy code into docker
COPY kms-omni-build/ /kms-omni-build/

COPY repository/ /root/.m2/repository

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
