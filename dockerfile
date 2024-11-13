FROM ubuntu:22.04

# Install dependencies
RUN apt-get update &&\
apt-get install -yq wget

# Install GPAC
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget https://download.tsi.telecom-paristech.fr/gpac/new_builds/gpac_latest_head_linux64.deb && \
    dpkg -i gpac_latest_head_linux64.deb; apt-get -fy install && \
    rm ./gpac_latest_head_linux64.deb

WORKDIR /server
COPY server/. .

# Expose ports
EXPOSE 8080

# Start serving
# CMD ["/bin/sh", "-c", "gpac flist:srcs=testvideo.mp4#video:floop=-1 flist:srcs=testvideo.mp4#audio:floop=-1 reframer:rt=on -o http://localhost:8080/live.mpd:segdur=6:cdur=1:profile=live:dmode=dynamic:rdirs=. --tfdt_traf"]

CMD ["/bin/sh", "-c", "gpac flist:srcs=testvideo.mp4#video:floop=-1 flist:srcs=testvideo.mp4#audio:floop=-1 reframer:rt=on -o http://localhost:8080/live.mpd:gpac:segdur=6:cdur=0.1:profile=live:dmode=dynamic:rdirs=.:asto=4 --tfdt_traf"]
# CMD ["/bin/sh", "-c", "gpac --tfdt_traf flist:srcs=testvideo.mp4#video:floop=-1 flist:srcs=testvideo.mp4#audio:floop=-1 reframer:rt=on -o http://localhost:8080/out.mpd:segdur=6:cdur=0.1:profile=live:dmode=dynamic"]
# CMD ["/bin/sh", "-c", "gpac --tfdt_traf -i testvideo.mp4#video:floop=-1 -i testvideo.mp4#audio:floop=-1 reframer:rt=on -segdur 6 -cdur 0.1 -o http://localhost:8080/out.mpd:profile=live"]

# Local deploy
# docker build -t my-ll-dash-stream .
# docker run -p 8080:8080 my-ll-dash-stream


# GCP deploy
# docker tag my-ll-dash-stream eu.gcr.io/cse4265-2024-101481573/gpac_resp/my-ll-dash-stream:latest
# docker push eu.gcr.io/cse4265-2024-101481573/gpac_resp/my-ll-dash-stream:latest
# gcloud app deploy --image-url eu.gcr.io/cse4265-2024-101481573/gpac_resp/my-ll-dash-stream::latest