// android/app/src/main/kotlin/com/example/rage_app/MainActivity.kt
// Flutter ↔ Android köprüsü.
// Kanal: com.example.rage_app/haptic
// Metodlar:
//   vibrateMaterial(materialType: String)  — materyal başına özel dalga şekli
//   vibrateImpact(intensity: Int)          — tek vuruş geri bildirimi

package com.example.rage_app

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "com.example.rage_app/haptic"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "vibrateMaterial" -> {
                        val materialType = call.argument<String>("materialType") ?: "digitalGlass"
                        vibrateMaterial(materialType)
                        result.success(null)
                    }
                    "vibrateImpact" -> {
                        val intensity = call.argument<Int>("intensity") ?: 128
                        vibrateImpact(intensity)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // -------------------------------------------------------------------------
    // Genel vibratör erişimi — API 31+ VibratorManager kullanır
    // -------------------------------------------------------------------------
    private fun getVibrator(): Vibrator {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val manager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            manager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
    }

    // -------------------------------------------------------------------------
    // Materyale özel titreşim profilleri
    // API 26+ — VibrationEffect.createWaveform
    // API < 26  — tek darbeli yedek
    // -------------------------------------------------------------------------
    private fun vibrateMaterial(materialType: String) {
        val vibrator = getVibrator()
        if (!vibrator.hasVibrator()) return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = when (materialType) {
                "digitalGlass" -> {
                    // Keskin, kısa kırılma sesi hissi
                    VibrationEffect.createWaveform(
                        longArrayOf(0, 30, 20, 15, 10, 5),
                        intArrayOf(0, 200, 0, 150, 0, 80),
                        -1
                    )
                }
                "porcelainVase" -> {
                    // Gümbür gümbür, ağır seramik kırılması
                    VibrationEffect.createWaveform(
                        longArrayOf(0, 60, 30, 40, 20, 20),
                        intArrayOf(0, 255, 0, 200, 0, 120),
                        -1
                    )
                }
                "crtMonitor" -> {
                    // Elektrik boşalması + mekanik çöküş
                    VibrationEffect.createWaveform(
                        longArrayOf(0, 10, 5, 10, 5, 80, 40, 30),
                        intArrayOf(0, 180, 0, 180, 0, 255, 0, 150),
                        -1
                    )
                }
                "bubbleWrap" -> {
                    // Balonların patlaması — hafif, ritmik
                    VibrationEffect.createWaveform(
                        longArrayOf(0, 8, 12, 8, 12, 8, 12),
                        intArrayOf(0, 100, 0, 100, 0, 80, 0),
                        -1
                    )
                }
                else -> VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE)
            }
            vibrator.vibrate(effect)
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(100)
        }
    }

    // -------------------------------------------------------------------------
    // Genel darbe titreşimi (yoğunluk 0–255)
    // -------------------------------------------------------------------------
    private fun vibrateImpact(intensity: Int) {
        val vibrator = getVibrator()
        if (!vibrator.hasVibrator()) return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val clampedIntensity = intensity.coerceIn(1, 255)
            vibrator.vibrate(
                VibrationEffect.createOneShot(40, clampedIntensity)
            )
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(40)
        }
    }
}
