package com.irveni.admin

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import me.pushy.sdk.Pushy
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "speakerphone_control"
    private var methodChannel: MethodChannel? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Start the Pushy background service
        Pushy.listen(this)
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupMethodChannel(flutterEngine)
    }
    
    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        try {
            methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            methodChannel?.setMethodCallHandler { call, result ->
                try {
                    println("Method called: ${call.method}")
                    when (call.method) {
                        "setSpeakerphoneOn" -> {
                            val enable = call.arguments as? Boolean
                            println("setSpeakerphoneOn called with: $enable")
                            if (enable != null) {
                                setSpeakerphoneOn(enable)
                                result.success(null)
                            } else {
                                result.error("INVALID_ARGUMENT", "Invalid argument", null)
                            }
                        }
                        "getSpeakerphoneStatus" -> {
                            println("getSpeakerphoneStatus called")
                            val isSpeakerOn = getSpeakerphoneStatus()
                            println("Returning speaker status: $isSpeakerOn")
                            result.success(isSpeakerOn)
                        }
                        "testSpeakerFunctionality" -> {
                            println("testSpeakerFunctionality called")
                            testSpeakerFunctionality()
                            result.success("Test completed")
                        }
                        "syncSpeakerState" -> {
                            println("syncSpeakerState called")
                            val currentState = getSpeakerphoneStatus()
                            println("Current speaker state: $currentState")
                            result.success(currentState)
                        }
                        else -> {
                            println("Unknown method: ${call.method}")
                            result.notImplemented()
                        }
                    }
                } catch (e: Exception) {
                    println("Error in method channel: ${e.message}")
                    e.printStackTrace()
                    result.error("METHOD_ERROR", e.message, null)
                }
            }
            println("Method channel setup completed successfully")
        } catch (e: Exception) {
            println("Error setting up method channel: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun setSpeakerphoneOn(enable: Boolean) {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            println("Setting speakerphone to: $enable")
            println("Current mode before: ${audioManager.mode}")
            println("Current speakerphone state before: ${audioManager.isSpeakerphoneOn}")
            
            // Set the audio mode first
            val targetMode = if (enable) {
                AudioManager.MODE_IN_COMMUNICATION
            } else {
                AudioManager.MODE_NORMAL
            }
            
            audioManager.mode = targetMode
            println("Audio mode set to: ${audioManager.mode}")
            
            // Set speakerphone state
            audioManager.isSpeakerphoneOn = enable
            println("Speakerphone state set to: ${audioManager.isSpeakerphoneOn}")
            
            // Force audio routing update
            if (enable) {
                audioManager.setSpeakerphoneOn(true)
                // Also try to set communication mode explicitly
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
            } else {
                audioManager.setSpeakerphoneOn(false)
                // Return to normal mode
                audioManager.mode = AudioManager.MODE_NORMAL
            }
            
            println("Final audio mode: ${audioManager.mode}")
            println("Final speakerphone state: ${audioManager.isSpeakerphoneOn}")
            
            // Verify the change
            val isActuallyOn = audioManager.isSpeakerphoneOn
            println("Verification - speakerphone is actually: $isActuallyOn")
            
        } catch (e: Exception) {
            println("Error setting speakerphone: ${e.message}")
            e.printStackTrace()
        }
    }
    
    private fun getSpeakerphoneStatus(): Boolean {
        return try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            println("AudioManager mode: ${audioManager.mode}")
            println("AudioManager isSpeakerphoneOn: ${audioManager.isSpeakerphoneOn}")
            
            // Method 1: Check if speakerphone is explicitly on
            val isSpeakerphoneOn = audioManager.isSpeakerphoneOn
            println("Method 1 - isSpeakerphoneOn: $isSpeakerphoneOn")
            
            // Method 2: Check if we're in communication mode and speaker is on
            val isInCommunicationMode = audioManager.mode == AudioManager.MODE_IN_COMMUNICATION
            println("Method 2 - isInCommunicationMode: $isInCommunicationMode")
            
            // Method 3: Check if we're in normal mode and speaker is on
            val isInNormalMode = audioManager.mode == AudioManager.MODE_NORMAL
            println("Method 3 - isInNormalMode: $isInNormalMode")
            
            // Method 4: Check if we're in call mode and speaker is on
            val isInCallMode = audioManager.mode == AudioManager.MODE_IN_CALL
            println("Method 4 - isInCallMode: $isInCallMode")
            
            // Method 5: Check actual audio output route (more reliable)
            val isSpeakerOutput = checkActualSpeakerOutput()
            println("Method 5 - isSpeakerOutput: $isSpeakerOutput")
            
            // Determine the final status - prioritize actual output check
            val finalStatus = isSpeakerOutput || isSpeakerphoneOn
            println("Final speaker status: $finalStatus")
            println("Audio mode: ${audioManager.mode}")
            println("Speakerphone state: $isSpeakerphoneOn")
            println("Actual speaker output: $isSpeakerOutput")
            
            finalStatus
        } catch (e: Exception) {
            println("Error getting speakerphone status: ${e.message}")
            e.printStackTrace()
            false
        }
    }
    
    private fun checkActualSpeakerOutput(): Boolean {
        return try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            
            // Check if we're in a mode that supports speakerphone
            val isInSpeakerMode = when (audioManager.mode) {
                AudioManager.MODE_IN_COMMUNICATION -> true
                AudioManager.MODE_IN_CALL -> true
                AudioManager.MODE_NORMAL -> true
                else -> false
            }
            
            // Check if speakerphone is actually on
            val isSpeakerOn = audioManager.isSpeakerphoneOn
            
            // Additional check: if we're in communication mode and speaker is on, it's definitely speaker output
            val isDefinitelySpeaker = (audioManager.mode == AudioManager.MODE_IN_COMMUNICATION && isSpeakerOn)
            
            println("checkActualSpeakerOutput:")
            println("  isInSpeakerMode: $isInSpeakerMode")
            println("  isSpeakerOn: $isSpeakerOn")
            println("  isDefinitelySpeaker: $isDefinitelySpeaker")
            
            isDefinitelySpeaker || (isInSpeakerMode && isSpeakerOn)
        } catch (e: Exception) {
            println("Error checking actual speaker output: ${e.message}")
            false
        }
    }
    
    private fun testSpeakerFunctionality() {
        try {
            println("=== Testing Speaker Functionality ===")
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            
            println("Initial state:")
            println("  Mode: ${audioManager.mode}")
            println("  Speakerphone: ${audioManager.isSpeakerphoneOn}")
            
            // Test 1: Set speaker to true
            println("\nTest 1: Setting speaker to true")
            audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
            audioManager.isSpeakerphoneOn = true
            println("  After setting to true:")
            println("    Mode: ${audioManager.mode}")
            println("    Speakerphone: ${audioManager.isSpeakerphoneOn}")
            
            // Test 2: Set speaker to false
            println("\nTest 2: Setting speaker to false")
            audioManager.isSpeakerphoneOn = false
            println("  After setting to false:")
            println("    Mode: ${audioManager.mode}")
            println("    Speakerphone: ${audioManager.isSpeakerphoneOn}")
            
            // Test 3: Set speaker to true again
            println("\nTest 3: Setting speaker to true again")
            audioManager.isSpeakerphoneOn = true
            println("  After setting to true again:")
            println("    Mode: ${audioManager.mode}")
            println("    Speakerphone: ${audioManager.isSpeakerphoneOn}")
            
            println("=== Test completed ===")
        } catch (e: Exception) {
            println("Error in testSpeakerFunctionality: ${e.message}")
            e.printStackTrace()
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Clean up method channel
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }
}