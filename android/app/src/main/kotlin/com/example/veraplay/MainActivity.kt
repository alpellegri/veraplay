package com.example.veraplay

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.Log

import java.util.Timer
import java.util.TimerTask
class MainActivity: FlutterActivity() {
/*
    private val CHANNEL = "flutter.native/helper"
    var serviceRunning = false
    var tone = ToneGenerator()
    var timer = Timer()

    init {
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
                call, result ->
            when (call.method) {
                "waveform" -> {
                    waveform(call, result)
                }
                "frequency" -> {
                    frequency(call, result)
                }
                "play" -> {
                    play(call, result)
                }
                "stop" -> {
                    stop(call, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun waveform(call: MethodCall, result: MethodChannel.Result) {
        var w = call.argument<String>("waveform")
        Log.v("TAG", "waveform" + w.toString())
        result.success("waveform")
    }

    private fun frequency(call: MethodCall, result: MethodChannel.Result) {
        var f = call.argument<Int>("frequency")
        // Log.v("TAG", "frequency: " + f.toString())
        if (f != null) {
            f = tone.setFrequency(f)
        }
        result.success("frequency")
    }

    private fun play(call: MethodCall, result: MethodChannel.Result) {
        Log.v("TAG", "play")
        tone.initTrack()
        tone.startPlaying()
        serviceRunning = true
        timer.schedule(object : TimerTask() {
            override fun run() {
                while (serviceRunning == true) {
                    tone.playback()
                }
            }
        }, 0)
        result.success("play")
    }

    private fun stop(call: MethodCall, result: MethodChannel.Result) {
        Log.v("TAG", "stop")
        tone.stopPlaying()
        serviceRunning = false
        result.success("stop")
    }
*/
}
