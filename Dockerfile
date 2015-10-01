FROM gpitfield/centos
ENV dir /usr/local
ENV bindir /usr/bin
WORKDIR ${dir}
RUN yum install -y zlib-devel \
&& git clone --depth 1 git://github.com/yasm/yasm.git
WORKDIR yasm
RUN autoreconf -fiv \
&& ./configure --prefix=${dir}/ffmpeg_build --bindir=${bindir} \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 git://git.videolan.org/x264
WORKDIR x264
RUN ./configure --prefix=${dir}/ffmpeg_build --bindir=${bindir} --enable-static \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
WORKDIR fdk-aac
RUN autoreconf -fiv \
&& ./configure --prefix=${dir}/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz \
&& tar xzvf lame-3.99.5.tar.gz && cd lame-3.99.5 \
&& ./configure --prefix=${dir}/ffmpeg_build --bindir=${bindir} --disable-shared --enable-nasm \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone https://git.xiph.org/opus.git
WORKDIR opus
RUN autoreconf -fiv \
&& ./configure --prefix=${dir}/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz && tar xzvf libogg-1.3.2.tar.gz
WORKDIR libogg-1.3.2
RUN ./configure --prefix=${dir}/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz && tar xzvf libvorbis-1.3.4.tar.gz
WORKDIR libvorbis-1.3.4
ENV LDFLAGS "-L/usr/local/ffmpeg_build/lib"
ENV CPPFLAGS "-I/usr/local/ffmpeg_build/include"
RUN ./configure --prefix=${dir}/ffmpeg_build --with-ogg=${dir}/ffmpeg_build --disable-shared \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
WORKDIR libvpx
RUN ./configure --prefix=${dir}/ffmpeg_build --disable-examples \
&& make && make install && make distclean
WORKDIR ${dir}
RUN git clone --depth 1 git://source.ffmpeg.org/ffmpeg
WORKDIR ffmpeg
ENV PKG_CONFIG_PATH "/usr/local/ffmpeg_build/lib/pkgconfig"
RUN ./configure --prefix=${dir}/ffmpeg_build --extra-cflags=-I${dir}/ffmpeg_build/include --extra-ldflags=-L${dir}/ffmpeg_build/lib --bindir=/usr/bin --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 && make && make install && make distclean
WORKDIR ${dir}
RUN rm -rf ffmpeg_build fdk-aac lame-3* libogg* libvorbis* libvpx* opus* x264* yasm*
