//
//  GameTheme.swift
//  Game Catalog
//
//  Created by mac on 20.11.2025.
//

import SwiftUI

// 1.🎨 Кольори та Градієнти
struct GameTheme {
    static let accent = Color.yellow  // Основний колір (зірочки)

    static let background = Color.black
    static let secondaryText = Color(white: 0.7)

    // Неонові акценти
    static let neonCyan = Color(red: 0.2, green: 0.9, blue: 1.0)  // Для кнопок/рамок
    static let neonToxic = Color(red: 0.1, green: 1.0, blue: 0.3)
    static let neonPurple = Color(red: 0.7, green: 0.3, blue: 1.0)  // Для акцентів
    static let starGold = Color(red: 1.0, green: 0.8, blue: 0.2)  // Для рейтингу

    // Градієнт для карток (глибокий космос)
    static let cardGradient = LinearGradient(
        colors: [
            Color(white: 0.1).opacity(0.6),
            Color(white: 0.05).opacity(0.8),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Градієнт для фону карток або екранів
    static let darkGradient = LinearGradient(
        colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)],
        startPoint: .top,
        endPoint: .bottom
    )

    // Градієнт для тіні на постерах
    static let posterShadow = LinearGradient(
        colors: [.clear, .black.opacity(0.9)],
        startPoint: .center,
        endPoint: .bottom
    )
}

struct CosmicGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var strokeColor: Color = .white.opacity(0.2)
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial) // Розмиття фону
            .background(Color.black.opacity(0.4)) // Затемнення
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // Неонова рамка
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [strokeColor.opacity(0.6), strokeColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
    }
}

// 🏷 Стиль для чіпсів (Жанри/Платформи)
struct CosmicChipStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .strokeBorder(GameTheme.neonCyan.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: GameTheme.neonCyan.opacity(0.3), radius: 4, x: 0, y: 0)
    }
}

// 🕹 Кнопка "Warp Drive" (Основна дія)
struct CosmicButtonStyle: ButtonStyle {
    var color: Color = GameTheme.neonCyan
    var isActive: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundColor(isActive ? .black : color)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    // Фон
                    if isActive {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                            .shadow(color: color.opacity(0.6), radius: 15) // Світіння
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black.opacity(0.6))
                            .stroke(color, lineWidth: 1.5)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

// --- Розширення ---
extension View {
    func cosmicGlass(cornerRadius: CGFloat = 16) -> some View {
        modifier(CosmicGlassModifier(cornerRadius: cornerRadius))
    }
    
    func cosmicChip() -> some View {
        modifier(CosmicChipStyle())
    }
}

// 2. 🔲 Модифікатор для "Скляного" ефекту (Glassmorphism)
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)  // Розмиття
            .background(Color.white.opacity(0.05))  // Легкий білий відтінок
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)  // Тонка рамка
            )
    }
}

// 3. 🕹 Стиль кнопки "Cyber Button"
struct CyberButtonStyle: ButtonStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    // Основний фон
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            color.opacity(configuration.isPressed ? 0.5 : 0.8)
                        )

                    // "Неонове" світіння
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: 2)
                        .shadow(
                            color: color,
                            radius: configuration.isPressed ? 5 : 10
                        )
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// ... (існуючий код GameTheme.swift)

// 4. 🦴 Ефект мерехтіння (Shimmer)
struct ShimmerView: View {
    @State private var isAnimating = false

    var body: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.2),  // Темний
                Color.gray.opacity(0.4),  // Світлий (блік)
                Color.gray.opacity(0.2),  // Темний
            ],
            startPoint: isAnimating
                ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5),
            endPoint: isAnimating
                ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5)
        )
        .onAppear {
            withAnimation(
                .linear(duration: 1.5).repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

// 5. 📳 Менеджер тактильного відгуку (Haptics)
class HapticManager {
    static let shared = HapticManager()

    /// Легкий удар (для кнопок, перемикачів)
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// Середній удар (для важливих дій, лайків)
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// Відчуття успіху/помилки
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

// 6. 🌈 "Живий" фон (Помітний ефект)
struct AnimatedBackground: View {
    @State private var isRotating = false

    var body: some View {
        ZStack {
            // 1. Глибока чорна база
            Color.black.ignoresSafeArea()
            //StarField()
            //    .ignoresSafeArea()

            // 2. Градієнт, що обертається
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.1, blue: 0.7),  // Насичений фіолетовий
                    Color.black,  // Чорний проміжок для контрасту
                    Color(red: 0.1, green: 0.4, blue: 0.8),  // Яскравий синій
                    Color.black,  // Чорний
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            // Збільшуємо ще більше, щоб кольорові плями були м'якшими
            .scaleEffect(2.5)

            // Обертання
            .rotationEffect(.degrees(isRotating ? 360 : 0))

            // Оптимальна прозорість: видно кольори, але текст читається
            .opacity(0.4)
            .blendMode(.screen)
            .ignoresSafeArea()

            // Додає трохи "туману", щоб згладити переходи
            .blur(radius: 60)
        }
        .onAppear {
            // duration: 10.0 — тепер крутиться швидше
            withAnimation(
                .linear(duration: 15.0).repeatForever(autoreverses: false)
            ) {
                isRotating = true
            }
        }
    }
}

struct StarField: View {
    // Кількість зірок
    let starCount = 80

    // Стан для зберігання параметрів зірок
    @State private var stars: [Star] = []

    // Модель однієї зірки
    struct Star: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        var blinkDuration: Double  // Швидкість мерехтіння
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(stars) { star in
                    Circle()
                        .fill(Color.white)
                        .frame(width: star.size, height: star.size)
                        .position(
                            x: star.x * geo.size.width,
                            y: star.y * geo.size.height
                        )
                        .opacity(0.7)  // Базова прозорість
                        // Анімація мерехтіння
                        .blinking(duration: star.blinkDuration)
                }
            }
        }
        .onAppear {
            generateStars()
        }
    }

    private func generateStars() {
        var newStars: [Star] = []
        for _ in 0..<starCount {
            newStars.append(
                Star(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1),
                    size: CGFloat.random(in: 1...3),  // Розмір від 1 до 3 пікселів
                    blinkDuration: Double.random(in: 1.5...4.0)  // Різна швидкість мерехтіння
                )
            )
        }
        self.stars = newStars
    }
}

// Допоміжний модифікатор для анімації мерехтіння
struct BlinkingModifier: ViewModifier {
    let duration: Double
    @State private var isFading = false

    func body(content: Content) -> some View {
        content
            .opacity(isFading ? 0.2 : 1.0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration).repeatForever(
                        autoreverses: true
                    )
                ) {
                    isFading = true
                }
            }
    }
}

// --- Розширення для зручного використання ---
extension View {
    /// Застосовує стиль скляної картки
    func glassCardStyle(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
    func blinking(duration: Double) -> some View {
        modifier(BlinkingModifier(duration: duration))
    }
}
