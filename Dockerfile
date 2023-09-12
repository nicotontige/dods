FROM nmanceau/steamcmd as game-install

# Download Day of Defeat: Source
RUN /app/steamcmd.sh +force_install_dir /games +login anonymous +app_update 232290 validate +quit

#=======================================================================
FROM debian:bookworm-slim

HEALTHCHECK NONE

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y ca-certificates lib32gcc-s1 libncurses5:i386 libsdl2-2.0-0:i386 libstdc++6 libstdc++6:i386 locales locales-all tmux wget
RUN apt-get clean
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set up Enviornment
RUN useradd --home /app --gid root --system DODS
RUN mkdir -p /app/.steam/sdk32
COPY --chown=DODS:root --from=game-install /games /app

# Linking steamclient.so to prevent srcds_run errors
RUN ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so

# Metamod & sourcemod installation
RUN wget -qO- https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz | tar xz -C /app/dod/
RUN wget -qO- https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz | tar xz -C /app/dod/

# Copy server config file
COPY --chown=DODS:root /dist /app

# Copy launch script
COPY --chown=DODS:root /launch.sh /app
RUN chmod +x /app/launch.sh
RUN chown DODS:root -R /app

USER DODS

WORKDIR /app

EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020/udp

CMD ["/app/launch.sh"]

ONBUILD USER root