FROM gpitfield/centos:base
ENV dir /usr/local
WORKDIR ${dir}
RUN yum install -y zlib-devel \
&& git clone --depth 1 git://github.com/yasm/yasm.git
WORKDIR yasm
RUN autoreconf -fiv \
&& ./configure --prefix=$/usr/local/ffmpeg_build --bindir=/usr/bin \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 git://git.videolan.org/x264
WORKDIR x264
RUN ./configure --prefix=$/usr/local/ffmpeg_build --bindir=/usr/bin --enable-static \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
WORKDIR fdk-aac
RUN autoreconf -fiv \
&& ./configure --prefix=/usr/local/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz \
&& tar xzvf lame-3.99.5.tar.gz && cd lame-3.99.5 \
&& ./configure --prefix=/usr/local/ffmpeg_build --bindir=/usr/bin --disable-shared --enable-nasm \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone https://git.xiph.org/opus.git
WORKDIR opus
RUN autoreconf -fiv \
&& ./configure --prefix=/usr/local/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz && tar xzvf libogg-1.3.2.tar.gz
WORKDIR libogg-1.3.2
RUN ./configure --prefix=/usr/local/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz && tar xzvf libvorbis-1.3.4.tar.gz
WORKDIR libvorbis-1.3.4
ENV LDFLAGS "-L/usr/local/ffmpeg_build/lib"
ENV CPPFLAGS "-I/usr/local/ffmpeg_build/include"
RUN ./configure --prefix=/usr/local/ffmpeg_build --with-ogg=/usr/local/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
WORKDIR libvpx
RUN ./configure --prefix=/usr/local/ffmpeg_build --disable-examples \
&& make && make install && make distclean