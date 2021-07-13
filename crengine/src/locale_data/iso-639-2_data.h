// ISO-639-2 Language registry.
// License: Public Domain.
// This file is autogenerated.
// Based on data from: https://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt
// file: ISO-639-2_utf-8.txt
// url: https://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt

#ifndef ISO639_2_DATA_H
#define ISO639_2_DATA_H

#ifdef __cplusplus
extern "C" {
#endif

#define ISO639_2_DATA_SZ	485
#define ISO639_2_UND_INDEX	452

struct iso639_2_rec {
	/**
	 * The three-letter 639-2 identifier. This is bibliographic application code.
	 * alpha-3 language code.
	 */
	const char* id;
	/**
	 * Equivalent 639-2 identifier of the terminology application code set, if there is one.
	 */
	const char* part2t;
	/**
	 * Equivalent 639-1 identifier, if there is one.
	 * alpha-2 language code.
	 */
	const char* part1;
	/**
	 * Reference language name.
	 */
	const char* ref_name;
};

extern const struct iso639_2_rec iso639_2_data[];

#ifdef __cplusplus
}
#endif

#endif	// ISO639_2_DATA_H
