import SwiftUI

@MainActor
private enum RoobLayout {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var contentWidth: CGFloat {
        isPad ? 1120 : 960
    }

    static var horizontalPadding: CGFloat {
        isPad ? 28 : 20
    }

    static var topPadding: CGFloat {
        isPad ? 28 : 20
    }

    static var bottomPadding: CGFloat {
        isPad ? 156 : 120
    }
}

struct RoobScreen<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoobTheme.pageGradient
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    content
                }
                .frame(maxWidth: RoobLayout.contentWidth, alignment: .leading)
                .padding(.horizontal, RoobLayout.horizontalPadding)
                .padding(.top, RoobLayout.topPadding)
                .padding(.bottom, RoobLayout.bottomPadding)
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
        .clipped()
    }
}

struct HeroCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [RoobTheme.ink, RoobTheme.royal, RoobTheme.plum],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(RoobTheme.gold.opacity(0.10))
                        .frame(width: 220, height: 220)
                        .offset(x: 60, y: -50)
                }
                Spacer()
            }

            VStack {
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.08))
                        .frame(width: 220, height: 18)
                        .rotationEffect(.degrees(-18))
                        .offset(x: 110, y: 18)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(.white.opacity(0.07))
                        .frame(width: 180, height: 14)
                        .rotationEffect(.degrees(-18))
                        .offset(x: 50, y: -8)
                }
            }

            VStack(alignment: .leading, spacing: 18) {
                Text(title.uppercased())
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(subtitle)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                content
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(RoobTheme.gold.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.28), radius: 24, y: 14)
    }
}

struct SurfaceCard<Content: View>: View {
    let title: String?
    let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let title {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
            }
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surface.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(RoobTheme.mist.opacity(0.75), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 8)
    }
}

struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.72))
                .textCase(.uppercase)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct BadgeRow: View {
    let items: [String]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(RoobTheme.surfaceRaised.opacity(0.9))
                    .clipShape(Capsule())
            }
        }
    }
}

struct ScreenHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(eyebrow.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(RoobTheme.gold)
                    .tracking(1.4)
                Text(title)
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.74))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            BrandLogoBadge(size: RoobLayout.isPad ? 86 : 68)
        }
    }
}

struct EditorialBanner: View {
    let eyebrow: String
    let headline: String
    let bodyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(RoobTheme.gold)
                .tracking(1.2)
            Text(headline.uppercased())
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text(bodyText)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct SplitMetricRow: View {
    let leftTitle: String
    let leftValue: String
    let rightTitle: String
    let rightValue: String

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                MetricBlock(title: leftTitle, value: leftValue)
                MetricBlock(title: rightTitle, value: rightValue)
            }

            VStack(spacing: 12) {
                MetricBlock(title: leftTitle, value: leftValue)
                MetricBlock(title: rightTitle, value: rightValue)
            }
        }
    }
}

struct MetricBlock: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(RoobTheme.gold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct TeamLogoView: View {
    let primary: Color
    let secondary: Color
    let text: String
    let size: CGFloat

    init(primary: Color, secondary: Color, text: String, size: CGFloat = 56) {
        self.primary = primary
        self.secondary = secondary
        self.text = text
        self.size = size
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [primary, secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: size * 0.32, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: 1)

            Text(text)
                .font(.system(size: size * 0.32, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}

struct BrandLogoBadge: View {
    let size: CGFloat

    init(size: CGFloat = 72) {
        self.size = size
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(RoobTheme.surfaceRaised.opacity(0.94))

            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .stroke(RoobTheme.gold.opacity(0.22), lineWidth: 1)

            Image("RoobLeagueLogo")
                .resizable()
                .scaledToFit()
                .padding(size * 0.12)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.22), radius: 14, y: 6)
        .accessibilityHidden(true)
    }
}

struct ActionChip: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(selected ? RoobTheme.gold : .white.opacity(0.78))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(selected ? RoobTheme.surfaceRaised.opacity(0.96) : RoobTheme.surface.opacity(0.78))
            )
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let containerWidth = proposal.width ?? .greatestFiniteMagnitude
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let spacingBefore = currentRowWidth == 0 ? 0 : spacing

            if currentRowWidth + spacingBefore + size.width > containerWidth {
                totalHeight += currentRowHeight == 0 ? 0 : currentRowHeight + spacing
                maxRowWidth = max(maxRowWidth, currentRowWidth)
                currentRowWidth = size.width
                currentRowHeight = size.height
            } else {
                currentRowWidth += spacingBefore + size.width
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }

        maxRowWidth = max(maxRowWidth, currentRowWidth)
        totalHeight += currentRowHeight

        return CGSize(width: maxRowWidth, height: totalHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var origin = CGPoint(x: bounds.minX, y: bounds.minY)
        var currentRowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let spacingBefore = origin.x == bounds.minX ? 0 : spacing

            if origin.x + spacingBefore + size.width > bounds.maxX {
                origin.x = bounds.minX
                origin.y += currentRowHeight + spacing
                currentRowHeight = 0
            }

            origin.x += spacingBefore
            subview.place(
                at: origin,
                anchor: .topLeading,
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )

            origin.x += size.width
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}
