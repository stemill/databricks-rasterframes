FROM databricksruntime/minimal:latest

RUN apt-get update && apt-get install --yes wget

ENV PATH /databricks/conda/bin:$PATH

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /databricks/conda && \
    rm miniconda.sh && \
    # Source conda.sh for all login and interactive shells.
    ln -s /databricks/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /etc/profile.d/conda.sh" >> ~/.bashrc && \
    # Set always_yes for non-interactive shells.
    conda config --system --set always_yes True && \
    conda clean --all
    
COPY env.yml /tmp/env.yml

RUN conda env create --file /tmp/env.yml && \
    rm -f /tmp/env.yml && \
    rm -rf $HOME/.cache/pip/*

# Set an environment variable used by Databricks to decide which conda environment to activate by default.
ENV DEFAULT_DATABRICKS_ROOT_CONDA_ENV=gdal
