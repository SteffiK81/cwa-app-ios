import UIKit
import OpenCombine

class AdmissionStateTableViewCell: UITableViewCell, UITextViewDelegate, ReuseIdentifierProviding {

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupView()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrides

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		updateBorderWidth()
	}

	// MARK: - Protocol UITextViewDelegate

	func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		LinkHelper.open(url: url, interaction: interaction) == .allow
	}

	// MARK: - Internal

	func configure(with cellModel: AdmissionStateCellModel) {
		titleLabel.text = cellModel.title
		titleLabel.isHidden = (cellModel.title ?? "").isEmpty
		titleLabel.accessibilityIdentifier = AccessibilityIdentifiers.HealthCertificate.AdmissionState.title
		
		subtitleLabel.text = cellModel.subtitle
		subtitleLabel.isHidden = (cellModel.subtitle ?? "").isEmpty
		subtitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.HealthCertificate.AdmissionState.subtitle

		descriptionLabel.text = cellModel.description
		descriptionLabel.isHidden = (cellModel.description ?? "").isEmpty
		descriptionLabel.accessibilityIdentifier = AccessibilityIdentifiers.HealthCertificate.AdmissionState.description

		faqLinkTextView.attributedText = cellModel.faqLink
		faqLinkTextView.isHidden = (cellModel.faqLink?.string ?? "").isEmpty
		faqLinkTextView.accessibilityIdentifier = AccessibilityIdentifiers.HealthCertificate.AdmissionState.faq

		roundedLabeledView?.configure(title: cellModel.shortTitle, gradientType: cellModel.gradientType)
		roundedLabeledView?.isHidden = (cellModel.shortTitle ?? "").isEmpty
	}

	// MARK: - Private
	
	private let backgroundContainerView: UIView = {
		let backgroundContainerView = UIView()
		backgroundContainerView.backgroundColor = .enaColor(for: .cellBackground2)
		backgroundContainerView.layer.borderColor = UIColor.enaColor(for: .hairline).cgColor
		if #available(iOS 13.0, *) {
			backgroundContainerView.layer.cornerCurve = .continuous
		}
		backgroundContainerView.layer.cornerRadius = 15.0
		backgroundContainerView.layer.masksToBounds = true

		return backgroundContainerView
	}()

	private let contentStackView: UIStackView = {
		let contentStackView = UIStackView()
		contentStackView.axis = .vertical
		contentStackView.alignment = .fill
		contentStackView.spacing = 6

		return contentStackView
	}()

	private let topStackView: UIStackView = {
		let titleStackView = AccessibleStackView()
		titleStackView.distribution = .fill
		titleStackView.alignment = .top
		titleStackView.spacing = 6

		return titleStackView
	}()
	
	private let titleStackView: UIStackView = {
		let topStackView = UIStackView()
		topStackView.axis = .vertical
		topStackView.distribution = .fill
		topStackView.alignment = .fill
		topStackView.spacing = 0

		return topStackView
	}()

	private let titleLabel: ENALabel = {
		let titleLabel = ENALabel(style: .headline)
		titleLabel.numberOfLines = 0
		titleLabel.textColor = .enaColor(for: .textPrimary1)
		titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

		return titleLabel
	}()

	private let subtitleLabel: ENALabel = {
		let subtitleLabel = ENALabel(style: .body)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.textColor = .enaColor(for: .textPrimary2)

		return subtitleLabel
	}()

	private lazy var roundedLabeledView: RoundedLabeledView? = {
		let nibName = String(describing: RoundedLabeledView.self)
		let nib = UINib(nibName: nibName, bundle: .main)

		return nib.instantiate(withOwner: self, options: nil).first as? RoundedLabeledView
	}()

	private let descriptionLabel: ENALabel = {
		let descriptionLabel = ENALabel(style: .body)
		descriptionLabel.numberOfLines = 0

		return descriptionLabel
	}()

	private let faqLinkTextView: UITextView = {
		let faqLinkTextView = UITextView()
		faqLinkTextView.backgroundColor = .enaColor(for: .cellBackground2)
		faqLinkTextView.isScrollEnabled = false
		faqLinkTextView.isEditable = false
		faqLinkTextView.textContainerInset = .zero
		faqLinkTextView.textContainer.lineFragmentPadding = .zero
		faqLinkTextView.textColor = .enaColor(for: .textPrimary1)
		faqLinkTextView.tintColor = .enaColor(for: .textTint)
		faqLinkTextView.linkTextAttributes = [
			.foregroundColor: UIColor.enaColor(for: .textTint),
			.underlineColor: UIColor.clear
		]

		return faqLinkTextView
	}()

	private func setupView() {
		backgroundColor = .clear
		contentView.backgroundColor = .clear
		selectionStyle = .none

		updateBorderWidth()

		faqLinkTextView.delegate = self

		backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(backgroundContainerView)

		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		backgroundContainerView.addSubview(contentStackView)
		
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(subtitleLabel)

		topStackView.addArrangedSubview(titleStackView)

		if let roundedLabeledView = roundedLabeledView {
			topStackView.addArrangedSubview(roundedLabeledView)
		}

		contentStackView.addArrangedSubview(topStackView)
		contentStackView.addArrangedSubview(descriptionLabel)
		contentStackView.setCustomSpacing(16, after: descriptionLabel)
		contentStackView.addArrangedSubview(faqLinkTextView)

		NSLayoutConstraint.activate(
			[
				backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
				backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
				backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
				backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

				contentStackView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 16.0),
				contentStackView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -16.0),
				contentStackView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 16.0),
				contentStackView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -16.0)
			]
		)
	}

	private func updateBorderWidth() {
		backgroundContainerView.layer.borderWidth = traitCollection.userInterfaceStyle == .dark ? 0 : 1
	}

}
