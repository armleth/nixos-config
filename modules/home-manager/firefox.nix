{ config, ... }:

{
    programs.firefox = {
        enable = true;

        policies = {
            ExtensionSettings = {
                # blocks all addons except the ones specified below
                "*".installation_mode = "blocked";

                # ublock origin
                "uBlock0@raymondhill.net" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "navbar";
                };

                # infinity pegasus
                "{9a066f3e-5093-471f-9495-fd8618959c81}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/infinity-pegasus/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "menupanel";
                };

                # bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "navbar";
                };

                # material icons for github
                "{eac6e624-97fa-4f28-9d24-c06c9b8aa713}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/material-icons-for-github/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "menupanel";
                };

                # authenticator
                "authenticator@mymindstorm" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/auth-helper/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "navbar";
                };

                # "sandvpn_@sandvpn.com" = {
                #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/sandvpn/latest.xpi";
                #   installation_mode = "force_installed";
                #   default_area = "menupanel";
                # };

                # languages packs
                "langpack-en-US@firefox.mozilla.org" = {
                    installation_mode = "normal_installed";
                    install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.programs.firefox.package.version}/linux-x86_64/xpi/en-US.xpi";
                };
                "langpack-fr@firefox.mozilla.org" = {
                    installation_mode = "normal_installed";
                    install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.programs.firefox.package.version}/linux-x86_64/xpi/fr.xpi";
                };
            };

            Preferences =
                let
                    lock-false = {
                        Value = false;
                        Status = "locked";
                    };
                    lock-true = {
                        Value = true;
                        Status = "locked";
                    };
                in
                {
                    "extensions.pocket.enabled" = lock-false;
                    "extensions.screenshots.disabled" = lock-true;
                    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                    "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
                };
        };
    };
}
