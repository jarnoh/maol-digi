FROM alpine as digabi
RUN apk add --no-cache p7zip wget

WORKDIR /work

# fetch image, peel it layer by layer (7z does the job, but does not support piped input)
RUN wget --progress=bar:force:noscroll -c http://static.abitti.fi/etcher-usb/koe-etcher.zip && \
 7z x -y koe-etcher.zip ytl/koe.img && rm koe-etcher.zip && \
 7z x -aou ytl/koe.img && rm ytl/koe.img && \
 7z x 1.primary.fat live/filesystem.squashfs && rm *.primary.* && \
 7z x live/filesystem.squashfs usr/local/share/maol-digi && rm live/filesystem.squashfs

FROM nginx
COPY --from=digabi --chown=nginx:nginx /work/usr/local/share/maol-digi/content /usr/share/nginx/html

