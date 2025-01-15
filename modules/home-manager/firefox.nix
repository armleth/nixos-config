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

                # GNOME Shell integration
                "chrome-gnome-shell@gnome.org" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/gnome-shell-integration/latest.xpi";
                    installation_mode = "force_installed";
                };

                # infinity pegasus
                "{9a066f3e-5093-471f-9495-fd8618959c81}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/infinity-pegasus/latest.xpi";
                    installation_mode = "force_installed";
                };

                # bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "navbar";
                };

                # 1password
                "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
                    installation_mode = "force_installed";
                    default_area = "navbar";
                };

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
            in {
                "extensions.pocket.enabled" = lock-false;
                "extensions.screenshots.disabled" = lock-true;
                "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
            };
        };
    };
}
