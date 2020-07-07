FROM alpine as digabi
RUN apk add --no-cache p7zip wget

WORKDIR /work

# fetch image, peel it layer by layer (7z does the job, but does not support piped input)
# HACK: koe.img contains 3*primary.img, we are interested in the second one, so we say yes once and ignore end of stream error
RUN wget -c http://static.abitti.fi/etcher-usb/koe-etcher.zip && \
 7z x -y koe-etcher.zip ytl/koe.img && rm koe-etcher.zip && \
 echo y|7z x ytl/koe.img primary.img||true && rm ytl/koe.img && \
 7z x primary.img live/filesystem.squashfs && rm primary.img && \
 7z x live/filesystem.squashfs usr/local/share/maol-digi && rm live/filesystem.squashfs

FROM nginx
COPY --from=digabi --chown=nginx:nginx /work/usr/local/share/maol-digi/content /usr/share/nginx/html

