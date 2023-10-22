import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.util.Base64;
public class Enc {
  public static void main(String[] args) throws Exception {
    if(args == null){
      System.err.println("args is null");
      System.exit(1);
    }
    if(args.length < 3){
      System.err.println("args needs to provide key, iv and text to encrypt");
      System.exit(1);
    }
    // Your AES-256 key (32 bytes)
    String key = args[0];

    // The initialization vector (IV) (16 bytes)
    String iv = args[1];

    // The string to be encrypted
    String plaintext = args[2];

    // Encrypt the string
    byte[] encryptedBytes = encrypt(plaintext, key, iv);
    String encryptedText = Base64.getEncoder().encodeToString(encryptedBytes);
    System.out.println("Encrypted: " + encryptedText);
    System.out.println("\n");

    // Decrypt the string
    String decryptedText = decrypt(Base64.getDecoder().decode(encryptedText), key, iv);
    System.out.println("Decrypted: " + decryptedText);
  }

  public static byte[] encrypt(String plaintext, String key, String iv) throws Exception {
    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
    SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(), "AES");
    IvParameterSpec initVector = new IvParameterSpec(iv.getBytes());
    cipher.init(Cipher.ENCRYPT_MODE, secretKey, initVector);
    return cipher.doFinal(plaintext.getBytes());
  }

  public static String decrypt(byte[] encryptedBytes, String key, String iv) throws Exception {
    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
    SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(), "AES");
    IvParameterSpec initVector = new IvParameterSpec(iv.getBytes());
    cipher.init(Cipher.DECRYPT_MODE, secretKey, initVector);
    byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
    return new String(decryptedBytes);
  }
}
