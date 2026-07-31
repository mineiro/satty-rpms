%bcond_with check

%global crate satty

Name:           satty
Version:        0.21.1
Release:        %autorelease
Summary:        Modern screenshot annotation tool for Linux

# LICENSE.dependencies contains a full license breakdown generated at build time
License:        MPL-2.0
URL:            https://github.com/Satty-org/Satty
Source0:        %{url}/archive/v%{version}/Satty-%{version}.tar.gz
Source1:        %{name}-%{version}-vendor.tar.xz

BuildRequires:  cargo-rpm-macros >= 24
BuildRequires:  pkgconfig(gtk4)
BuildRequires:  pkgconfig(libadwaita-1)
BuildRequires:  pkgconfig(epoxy)
BuildRequires:  pkgconfig(fontconfig)
BuildRequires:  pkgconfig(pangocairo)
BuildRequires:  pkgconfig(gdk-pixbuf-2.0)

%global _description %{expand:
Satty is a modern screenshot annotation tool for Linux, designed for
wlroots-based compositors. It provides smooth hardware-accelerated
rendering and an uncomplicated interface for marking up and annotating
screenshots.}

%description %{_description}

%prep
%autosetup -n Satty-%{version} -p1
tar -xJf %{SOURCE1}
%cargo_prep -v vendor

%build
# ci-release writes completions/ and man/ outside OUT_DIR for packaging
%cargo_build -f ci-release
%{cargo_license_summary}
%{cargo_license} > LICENSE.dependencies
%{cargo_vendor_manifest}

%install
install -Dpm0755 target/release/%{name} %{buildroot}%{_bindir}/%{name}
install -Dpm0644 %{name}.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop
install -Dpm0644 assets/%{name}.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
install -Dpm0644 org.satty.Satty.metainfo.xml %{buildroot}%{_metainfodir}/org.satty.Satty.metainfo.xml
install -Dpm0644 completions/%{name}.bash %{buildroot}%{bash_completions_dir}/%{name}
install -Dpm0644 completions/%{name}.fish %{buildroot}%{fish_completions_dir}/%{name}.fish
install -Dpm0644 completions/_%{name} %{buildroot}%{zsh_completions_dir}/_%{name}
install -Dpm0644 man/%{name}.1 %{buildroot}%{_mandir}/man1/%{name}.1

%if %{with check}
%check
%cargo_test -f ci-release
%endif

%files
%license LICENSE
%license LICENSE.dependencies
%license cargo-vendor.txt
%doc README.md
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
%{_metainfodir}/org.satty.Satty.metainfo.xml
%{bash_completions_dir}/%{name}
%{fish_completions_dir}/%{name}.fish
%{zsh_completions_dir}/_%{name}
%{_mandir}/man1/%{name}.1*

%changelog
%autochangelog
