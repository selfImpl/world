package com.qunar.hotel.qtypeahead.util;

import java.io.*;
import java.util.*;

import org.apache.log4j.Logger;

public class FileTools {
	protected static Logger logger = Logger.getLogger(FileTools.class);

	public static void appendLine(String filePath, String line)
			throws IOException {
		try {
			BufferedWriter bw = new BufferedWriter(new FileWriter(filePath,
					true));
			bw.write(line + "\n");
			bw.close();
		} catch (IOException e) {
			throw e;
		}
	}

	public static void writeFile(String filePath, String content)
			throws Exception {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter(filePath));
			bw.write(content);
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (bw != null)
					bw.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
		}
	}

	public static void writeList(String filePath, List<String> list,
			String encoding) throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(filePath), encoding));
			for (String line : list) {
				bw.write(line + "\n");
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (bw != null)
					bw.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
		}
	}

	public static void writeFile(String filePath, String content,
			String encoding) throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(filePath), encoding));
			bw.write(content);
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (bw != null)
					bw.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
		}
	}

	public static String getFileName(String shortName) {
		if (shortName == null)
			return null;
		int index = shortName.lastIndexOf(".");
		if (index == -1)
			return shortName;
		return shortName.substring(0, index);
	}

	public static String getFileName(File file) {
		return getFileName(file.getName());
	}

	public static String readFile(String filePath) throws IOException {
		StringBuilder sb = new StringBuilder("");
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(filePath));
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line + "\n");
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}

		}
		return sb.toString();
	}

	public static List<String> readFile2List(String filePath)
			throws IOException {
		List<String> lines = new ArrayList<String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(filePath));
			String line;
			while ((line = br.readLine()) != null) {
				lines.add(line);
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}

		}
		return lines;
	}
	
	public static List<String> readFile2List(InputStream is, String encoding) throws IOException{
		List<String> lines = new ArrayList<String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(is, encoding));
			String line;
			while ((line = br.readLine()) != null) {
				lines.add(line);
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}

		}
		return lines;
	}

	public static List<String> readFile2List(String filePath, String encoding)
			throws IOException {
		List<String> lines = new ArrayList<String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(
					filePath), encoding));
			String line;
			while ((line = br.readLine()) != null) {
				lines.add(line);
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}

		}
		return lines;
	}

	public static String readFile(String filePath, String encoding)
			throws IOException {
		StringBuilder sb = new StringBuilder("");
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(
					filePath), encoding));
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line + "\n");
			}
		} catch (IOException e) {
			throw e;
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}

		}
		return sb.substring(0, sb.length() - 1);
	}

	public static void makeDirs(String path) {
		File dir = new File(path);
		dir.mkdirs();
	}

	/**
	 * Create a new temporary directory. Use something like
	 * {@link #recursiveDelete(File)} to clean this directory up since it isn't
	 * deleted automatically
	 * 
	 * @return the new directory
	 * @throws IOException
	 *             if there is an error creating the temporary directory
	 */
	public static File createTempDir() throws IOException {
		final File sysTempDir = new File(System.getProperty("java.io.tmpdir"));
		File newTempDir;
		final int maxAttempts = 9;
		int attemptCount = 0;
		do {
			attemptCount++;
			if (attemptCount > maxAttempts) {
				throw new IOException(
						"The highly improbable has occurred! Failed to "
								+ "create a unique temporary directory after "
								+ maxAttempts + " attempts.");
			}
			String dirName = UUID.randomUUID().toString();
			newTempDir = new File(sysTempDir, dirName);
		} while (newTempDir.exists());

		if (newTempDir.mkdirs()) {
			return newTempDir;
		} else {
			throw new IOException("Failed to create temp dir named "
					+ newTempDir.getAbsolutePath());
		}
	}

	/**
	 * Recursively delete file or directory
	 * 
	 * @param fileOrDir
	 *            the file or dir to delete
	 * @return true iff all files are successfully deleted
	 */
	public static boolean recursiveDelete(File fileOrDir) {
		if (fileOrDir.isDirectory()) {
			// recursively delete contents
			for (File innerFile : fileOrDir.listFiles()) {
				if (!recursiveDelete(innerFile)) {
					return false;
				}
			}
		}

		return fileOrDir.delete();
	}

}
