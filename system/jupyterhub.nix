{ config, lib, pkgs, ... }: {

  services.jupyterhub = {
    enable = true;
    jupyterlabEnv = pkgs.python312.withPackages
      (p: with p; [ jupyterhub jupyterlab ipython jupyter notebook ipykernel ]);
    kernels = {
      python312 = let
        env = (pkgs.python312.withPackages (python312Packages:
          with python312Packages; [
            ipykernel
            pandas
            scikit-learn
            numpy
            seaborn
            matplotlib
            scipy
          ]));
      in {
        displayName = "Python 3";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        # logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        # logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
      R = let
        env = (pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [ IRkernel tidyverse tidymodels ];
        });
      in {
        displayName = "R for ML";
        argv = [
          "${pkgs.R}/bin/R"
          "--slave"
          "-e"
          "IRkernel::main()"
          "--args"
          "{connection_file}"
        ];
        language = "R";
        # logo32 = "${env.sitePackages}/IRKernel/resources/logo-32x32.png";
        # logo64 = "${env.sitePackages}/IRkernel/resources/logo-64x64.png";
      };
    };
  };
}
