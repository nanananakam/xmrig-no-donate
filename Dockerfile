FROM alpine

RUN apk add git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers bash && \
    git clone https://github.com/xmrig/xmrig.git && \
    sed -i -e 's/DonateLevel = 1/DonateLevel = 0/g' /xmrig/src/donate.h && \
    mkdir xmrig/build && \
    cd xmrig/scripts && ./build_deps.sh && cd ../build && \
    cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON && \
    make -j$(nproc)

FROM alpine

COPY --from=0 /xmrig/build/xmrig /
COPY config.json /

ENTRYPOINT ["/xmrig"]