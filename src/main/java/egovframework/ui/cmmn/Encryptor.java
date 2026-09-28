package egovframework.ui.cmmn;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

public class Encryptor {
	private static String encoding = "UTF-8";
	private static String defaultKey = PropUtil.ENC_KEY;              // 암호화 Key정보(16자리)
	
	public static String getEncryptionKey(String xValue, String cmpIp) {
		if(xValue==null || cmpIp==null) {
			return defaultKey;
		}
		
		try {
			StringBuffer sbKey = new StringBuffer();
			sbKey.append(xValue).append(Integer.toHexString(Integer.parseInt(cmpIp))).append(Integer.toOctalString(Integer.parseInt(cmpIp)));
			String key = sbKey.toString();
			key = key.substring(0,16);
			//String key = xValue + Integer.toHexString(Integer.parseInt(cmpIp)) + Integer.toOctalString(Integer.parseInt(cmpIp));
			//key = key.substring(0,16);
			return key;
		} catch (Exception ex) {
			return defaultKey;
		}
	}

	public static String encryptAES(String valueToEncrypt) throws Exception {
		return encryptAES(valueToEncrypt, getEncryptionKey(null, null));
	}
	
	public static String encryptAES(String valueToEncrypt, String encryptionKey) throws Exception {
		byte[] preSharedKey = encryptionKey.getBytes();  
		byte[] iv = encryptionKey.getBytes();
		byte[] data = valueToEncrypt.getBytes(encoding);
		SecretKey aesKey = new SecretKeySpec(preSharedKey, "AES");              
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, aesKey, new IvParameterSpec(iv)); 
		byte[] output = cipher.doFinal(data);       
		String encryptedText = new String(Hex.encodeHex(output));
		return encryptedText;
	}

	public static String decryptAES(String valueToDecrypt) throws Exception {
		return decryptAES(valueToDecrypt, getEncryptionKey(null, null));
	}
	
	public static String decryptAES(String valueToDecrypt,  String encryptionKey) throws Exception {     
		int len = valueToDecrypt.length();     
		byte[] data = new byte[len / 2];    
		for (int i = 0; i < len; i += 2) {     
			
			Integer digit = (Character.digit(valueToDecrypt.charAt(i), 16) << 4) + Character.digit(valueToDecrypt.charAt(i+1), 16);
			data[i / 2] = digit.byteValue();    
		}

		byte[] keyBytes = encryptionKey.getBytes(encoding);
		byte[] ivBytes = keyBytes;
		IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec spec = new SecretKeySpec(keyBytes, "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");     
		cipher.init(Cipher.DECRYPT_MODE, spec, ivSpec);
		byte[] output = cipher.doFinal(data);
		String decryptedText = new String(output);
		return decryptedText;
	}
	
	// 명칭을 DECODEER 함.
	public static String decodeName(String value ) {
		String rtn = "" ;
		try {
			if(value.startsWith("=?UTF-8?B?")){
				String base64Value = value.substring(10,value.indexOf("?=") );
				byte[] decodedValue = Base64.decodeBase64(base64Value.getBytes()); 
				String decodedString = new String( decodedValue, "UTF-8" );
				rtn = decodedString;
			}
		} catch(Exception e){
			return "false";
		}
		return rtn ;
	}

}