using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;

using System.Security.Cryptography;
using System.IO;
using Microsoft.Win32.SafeHandles;

namespace rhashgen
{
    class clhasher
    {
        public enum hashType {nothing, md5, sha1};

        public static string getHash(string input, hashType type, bool isFilePath)
        {
            string result = "";

            switch (type)
            {
                case hashType.md5:
                    result = getMd5Hash(input, isFilePath);
                    break;
                case hashType.sha1:
                    result = getSha1Hash(input, isFilePath);
                    break;
            }

            return result;
        }

        private static string getSha1Hash(string input, bool isFilePath)
        {
            byte[] result;
            SHA1 sha = new SHA1CryptoServiceProvider();
            
            if (isFilePath && !File.Exists(input))
                return "-1"; //file don't exist

            FileStream fs;

            if (isFilePath)
            {
                fs = File.Open(input, FileMode.Open, FileAccess.Read, FileShare.None);
                // Convert the input string to a byte array and compute the hash.
                result = sha.ComputeHash(fs);
                fs.Close();
            }
            else
            {
                // This is one implementation of the abstract class SHA1.
                result = sha.ComputeHash(Encoding.Default.GetBytes(input));
            }

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < result.Length; i++)
            {
                sBuilder.Append(result[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

        // Hash an input string and return the hash as
        // a 32 character hexadecimal string.
        public static string getMd5Hash(string input, bool isFilePath)
        {
            if (isFilePath && !File.Exists(input))
                return "-1"; //file don't exist

            // Create a new instance of the MD5CryptoServiceProvider object.
            MD5 md5Hasher = new MD5CryptoServiceProvider(); //MD5.Create();
            byte[] data;
            FileStream fs;

            if (isFilePath)
            {
                fs = File.Open(input, FileMode.Open, FileAccess.Read, FileShare.None);
                // Convert the input string to a byte array and compute the hash.
                data = md5Hasher.ComputeHash(fs);
                fs.Close();
            }
            else
            {
                // Convert the input string to a byte array and compute the hash.
                data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(input));
            }

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

    }
}
