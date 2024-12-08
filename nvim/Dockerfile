FROM alpine:3

RUN app add --no-cache neovim git curl fzf ripgrep gcc musl-dev make g++ && \
  mkdir -p /project

COPY init.lua /root/.config/nvim/init.lua

WORKDIR /project

ENTRYPOINT ["nvim"]
CMD ["/project"]
