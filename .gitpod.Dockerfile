FROM gitpod/workspace-postgres
USER gitpod

# Docker build does not rebuild an image when a base image is changed, increase this counter to trigger it
ENV TRIGGER_REBUILD 1

# Install the Ruby version specified in '.ruby-version'
COPY --chown=gitpod:gitpod .ruby-version /tmp
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-$(cat /tmp/.ruby-version) && rvm use ruby-$(cat /tmp/.ruby-version) --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc
