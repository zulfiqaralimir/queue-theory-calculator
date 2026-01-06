# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- iOS app release
- Multi-language support
- Historical data tracking
- Team collaboration features
- API for integrations

## [1.0.0] - 2026-01-06

### Added
- Initial release of Queue Theory Staffing Calculator
- Flutter mobile app for Android
- Responsive web application
- Python library implementation
- Core queue theory calculations (M/M/c model)
- Freemium monetization model for mobile
- SaaS pricing tiers for web
- Comprehensive documentation
- Algorithm guide and tutorials
- Revenue analysis and business model
- Example scenarios (coffee shop, bank, call center)
- PDF export functionality (premium feature)
- Scenario saving (premium feature)
- Dark mode support (mobile)
- Real-time calculation results
- Multiple staffing scenario comparisons
- Cost analysis and ROI calculations

### Documentation
- Complete README.md with setup instructions
- ALGORITHM_GUIDE.md explaining the mathematics
- WEB_VS_MOBILE_GUIDE.md for platform comparison
- REVENUE_ANALYSIS.md with monetization strategies
- STAFFING_WORKSHEET.md for data collection
- CONTRIBUTING.md for contributors
- MIT License

### Technical
- Implemented Erlang C formula
- Traffic intensity calculations
- Probability distributions (Poisson, Exponential)
- Stochastic modeling for random arrivals
- Responsive UI design
- Cross-platform compatibility
- Offline calculation support (mobile)
- Local data persistence (mobile)

## [0.9.0] - 2025-12-15 (Beta)

### Added
- Beta testing phase
- Core calculation engine
- Basic mobile UI
- Basic web UI
- Python prototype

### Changed
- Refined calculation algorithms
- Improved user interface
- Optimized performance

### Fixed
- Edge case handling for extreme values
- Calculation accuracy improvements
- UI responsiveness issues

## [0.5.0] - 2025-11-01 (Alpha)

### Added
- Initial prototype
- Basic queue theory implementation
- Command-line calculator
- Core mathematical models

### Notes
- Internal testing only
- Proof of concept validation

---

## Version Numbering

We use [Semantic Versioning](https://semver.org/):
- **MAJOR** version: Incompatible API changes
- **MINOR** version: New functionality (backwards-compatible)
- **PATCH** version: Bug fixes (backwards-compatible)

## Release Process

1. Update CHANGELOG.md with changes
2. Update version in:
   - `mobile/pubspec.yaml`
   - `python/setup.py`
   - `web/index.html` (meta tag)
3. Create git tag: `git tag -a v1.0.0 -m "Version 1.0.0"`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub release with release notes
6. Deploy to stores/hosting

## Future Roadmap

### Version 1.1 (Q2 2026)
- [ ] iOS app release
- [ ] Enhanced export options (Excel, CSV)
- [ ] Email reporting
- [ ] Notification system
- [ ] Performance improvements

### Version 1.5 (Q3 2026)
- [ ] Team collaboration features
- [ ] Advanced analytics dashboard
- [ ] Integration with scheduling software
- [ ] API access for enterprise
- [ ] White-label options

### Version 2.0 (Q4 2026)
- [ ] Machine learning predictions
- [ ] Real-time queue monitoring
- [ ] Video tutorials
- [ ] Advanced simulation modes
- [ ] Industry-specific templates

## Support

For questions about releases:
- Check [GitHub Releases](https://github.com/yourusername/queue-theory-calculator/releases)
- Read the [Documentation](./docs/)
- Open an [Issue](https://github.com/yourusername/queue-theory-calculator/issues)

[Unreleased]: https://github.com/yourusername/queue-theory-calculator/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/queue-theory-calculator/releases/tag/v1.0.0
[0.9.0]: https://github.com/yourusername/queue-theory-calculator/releases/tag/v0.9.0
[0.5.0]: https://github.com/yourusername/queue-theory-calculator/releases/tag/v0.5.0
