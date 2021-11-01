{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      clearurls
      darkreader
      facebook-container
      i-dont-care-about-cookies
      privacy-badger
      flagfox
      kristofferhagen-nord-theme
      sponsorblock
      translate-web-pages
      floccus
    ];
    profiles."kranzes" = {
      settings = {
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "beacon.enabled" = false;
        "breakpad.reportUR" = "";
        "browser.compactmode.show" = true;
        "browser.contentblocking.category" = "strict";
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.pocket.enabled" = false;
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
        "browser.send_pings" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uidensity" = 1;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "dom.security.https_only_mode" = true;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.activeThemeID" = "{e410fec2-1cbd-4098-9944-e21e708418af}";
        "gfx.webrender.all" = true;
        "network.dns.blockDotOnion" = true;
        "network.stricttransportsecurity.preloadlist" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.firstparty.isolate" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "security.insecure_password.ui.enabled" = true;
        "security.ssl.errorReporting.automatic" = false;
        "services.sync.engine.addons" = false;
        "services.sync.addons.ignoreUserEnabledChanges" = true;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
      };
    };
  };
}

