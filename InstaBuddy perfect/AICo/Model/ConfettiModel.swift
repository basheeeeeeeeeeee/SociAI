//
//  ConfettiView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/26/24.
//

import SwiftUI
import UIKit

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        createConfettiEmitter(in: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func createConfettiEmitter(in view: UIView) {
        let confettiLayer = CAEmitterLayer()

        confettiLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 0)
        confettiLayer.emitterShape = .line
        confettiLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 1)

        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPink]
        let images: [UIImage] = [
            UIImage(systemName: "circle.fill")!,
            UIImage(systemName: "star.fill")!,
            UIImage(systemName: "triangle.fill")!,
            UIImage(systemName: "diamond.fill")!
        ]

        let cells = images.map { (image) -> CAEmitterCell in
            let cell = CAEmitterCell()
            cell.contents = image.cgImage
            cell.birthRate = 10
            cell.lifetime = 10
            cell.velocity = CGFloat.random(in: 150...300)
            cell.scale = 0.1
            cell.scaleRange = 0.2
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3.5
            cell.spinRange = 1.0
            cell.color = colors.randomElement()?.cgColor
            return cell
        }

        confettiLayer.emitterCells = cells
        view.layer.addSublayer(confettiLayer)

        // Make it last for a short duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            confettiLayer.birthRate = 0
        }
    }
}
