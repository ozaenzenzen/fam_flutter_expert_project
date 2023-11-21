import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/domain/entities/genre_entity.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';

final testMovie = MovieEntity(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetailEntity(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [GenreEntity(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = MovieEntity.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  dataType: DataType.Movie.index,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'dataType': DataType.Movie.index,
};

final testPopularTvSeries = ResultTvSeries(
  adult: false,
  backdropPath: "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
  genreIds: [10763],
  id: 94722,
  originCountry: ["DE"],
  originalLanguage: "de",
  originalName: "Tagesschau",
  overview: "German daily news program, the oldest still existing program on German television.",
  popularity: 3330.836,
  posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
  firstAirDate: DateTime.parse("1952-12-26"),
  name: "Tagesschau",
  voteAverage: 7.155,
  voteCount: 165,
);

final testPopularTvSeriesList = TvSeriesResponseModel(
  results: [testPopularTvSeries],
);

final testOnTheAirTvSeries = ResultTvSeries(
  adult: false,
  backdropPath: "/aDRIKJuB63tuJUZf1O4mRmbMTVw.jpg",
  genreIds: [10764, 99],
  id: 6480,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "House Hunters",
  overview:
      "Hosted by Suzanne Whang, the show takes viewers behind the scenes as individuals, couples and families learn what to look for and decide whether or not a home is meant for them. Focusing on the emotional experience of finding and purchasing a new home, each episode follows a prospective buyer and real estate agent through the home-buying process, from start to finish.",
  popularity: 2622.744,
  posterPath: "/7Bsr9ogG0q6yHtNuIp6bJ6EFpbH.jpg",
  firstAirDate: DateTime.parse("1999-09-30"),
  name: "House Hunters",
  voteAverage: 5.288,
  voteCount: 26,
);

final testOnTheAirTvSeriesList = TvSeriesResponseModel(
  results: [testOnTheAirTvSeries],
);

final testTopRatedTvSeries = ResultTvSeries(
  adult: false,
  backdropPath: "/9faGSFi5jam6pDWGNd0p8JcJgXQ.jpg",
  genreIds: [18, 80],
  id: 1396,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Breaking Bad",
  overview:
      "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
  popularity: 409.595,
  posterPath: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg",
  firstAirDate: DateTime.parse("2008-01-20"),
  name: "Breaking Bad",
  voteAverage: 8.894,
  voteCount: 12650,
);

final testTopRatedSeriesList = TvSeriesResponseModel(
  results: [testTopRatedTvSeries],
);

final testSearchTvSeries = ResultTvSeries(
  adult: false,
  backdropPath: "/q3jHCb4dMfYF6ojikKuHd6LscxC.jpg",
  genreIds: [18, 10765],
  id: 84958,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Loki",
  overview:
      "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant” or help fix the timeline and stop a greater threat.",
  popularity: 1351.888,
  posterPath: "/voHUmluYmKyleFkTu3lOXQG702u.jpg",
  firstAirDate: DateTime.parse("2021-06-09"),
  name: "Loki",
  voteAverage: 8.181,
  voteCount: 10742,
);

final testSearchTvSeriesList = TvSeriesResponseModel(
  results: [testSearchTvSeries],
);

final testTvDetail = TvDetailResponseModel(
    adult: false,
    backdropPath: "/q3jHCb4dMfYF6ojikKuHd6LscxC.jpg",
    createdBy: [
      CreatedBy(
        id: 2094567,
        creditId: "6001713e7390c0003df730af",
        name: "Michael Waldron",
        gender: 2,
        profilePath: "/5d6wkYnJgkVAzThqnnwOLNDzACM.jpg",
      )
    ],
    episodeRunTime: [52],
    firstAirDate: DateTime.parse("2021-06-09"),
    genres: [
      Genre(
        id: 18,
        name: "Drama",
      ),
      Genre(
        id: 10765,
        name: "Sci-Fi & Fantasy",
      ),
    ],
    homepage: "https://www.disneyplus.com/series/wp/6pARMvILBGzF",
    id: 84958,
    inProduction: true,
    languages: ["en"],
    lastAirDate: DateTime.parse("2023-11-09"),
    lastEpisodeToAir: LastEpisodeToAir(
      id: 4447783,
      name: "Glorious Purpose",
      overview: "Loki learns the true nature of 'glorious purpose' as he rectifies the past.",
      voteAverage: 8.515,
      voteCount: 33,
      airDate: DateTime.parse("2023-11-09"),
      episodeNumber: 6,
      episodeType: "finale",
      productionCode: "",
      runtime: 59,
      seasonNumber: 2,
      showId: 84958,
      stillPath: "/avCnQZPvHbqDLWMqlRNtayG732A.jpg",
    ),
    name: "Loki",
    nextEpisodeToAir: null,
    networks: [
      Network(
        id: 2739,
        logoPath: "/uzKjVDmQ1WRMvGBb7UNRE0wTn1H.png",
        name: "Disney+",
        originCountry: "",
      ),
    ],
    numberOfEpisodes: 12,
    numberOfSeasons: 2,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Loki",
    overview:
        "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant” or help fix the timeline and stop a greater threat.",
    popularity: 1351.888,
    posterPath: "/voHUmluYmKyleFkTu3lOXQG702u.jpg",
    productionCompanies: [
      Network(
        id: 420,
        logoPath: "/hUzeosd33nzE5MCNsZxCGEKTXaQ.png",
        name: "Marvel Studios",
        originCountry: "US",
      ),
      Network(
        id: 176762,
        logoPath: null,
        name: "Kevin Feige Productions",
        originCountry: "US",
      ),
    ],
    productionCountries: [
      ProductionCountry(
        iso31661: "US",
        name: "United States of America",
      ),
    ],
    seasons: [
      Season(
        airDate: DateTime.parse("2021-06-09"),
        episodeCount: 6,
        id: 114355,
        name: "Season 1",
        overview: "Loki, the God of Mischief, steps out of his brother's shadow to embark on an adventure that takes place after the events of \"Avengers: Endgame.\"",
        posterPath: "/8uVqe9ThcuYVNdh4O0kuijIWMLL.jpg",
        seasonNumber: 1,
        voteAverage: 7.8,
      ),
      Season(
        airDate: DateTime.parse("2023-10-05"),
        episodeCount: 6,
        id: 341180,
        name: "Season 2",
        overview:
            "In the aftermath of Season 1, Loki finds himself in a battle for the soul of the Time Variance Authority. Along with Mobius, Hunter B-15 and a team of new and returning characters, Loki navigates an ever-expanding and increasingly dangerous multiverse in search of Sylvie, Judge Renslayer, Miss Minutes and the truth of what it means to possess free will and glorious purpose.",
        posterPath: "/yZjaiiE0gRAAGX1oyD5fkkARLcF.jpg",
        seasonNumber: 2,
        voteAverage: 7.9,
      ),
    ],
    spokenLanguages: [
      SpokenLanguage(
        englishName: "English",
        iso6391: "en",
        name: "English",
      ),
    ],
    status: "Returning Series",
    tagline: "Loki's time has come.",
    type: "Scripted",
    voteAverage: 8.181,
    voteCount: 10744);

final testTvRecommendation = ResultTvSeries(
  firstAirDate: DateTime.parse("1981-09-08"),
  genreIds: [35],
  id: 72,
  name: "Only Fools and Horses",
  originCountry: ["GB"],
  originalLanguage: "en",
  originalName: "Only Fools and Horses",
  overview: "The misadventures of two wheeler dealer brothers Del Boy and Rodney Trotter of “Trotters Independent Traders PLC” who scrape their living by selling dodgy goods believing that next year they will be millionaires.",
  popularity: 13.616,
  voteAverage: 7.9,
  voteCount: 179,
  posterPath: 'abc',
);

final testTvRecommendationList = TvSeriesResponseModel(
  results: [testTvRecommendation],
);
