import '../language_models/models/models.dart';
import '../prompts/models/models.dart';

/// Options for formatting instructions.
interface class FormatInstructionsOptions {}

/// {@template base_llm_output_parser}
/// Class to parse the output of an LLM call.
/// {@endtemplate}
abstract class BaseLLMOutputParser<LLMOutput extends Object,
    ParserOutput extends Object> {
  /// {@macro base_llm_output_parser}
  const BaseLLMOutputParser();

  /// Parse LLM result.
  Future<ParserOutput> parseResult(
    final List<LanguageModelGeneration<LLMOutput>> result,
  );

  /// Optional method to parse the output of an LLM call with a prompt.
  Future<ParserOutput> parseResultWithPrompt(
    final List<LanguageModelGeneration<LLMOutput>> result,
    final PromptValue prompt,
  ) async {
    return parseResult(result);
  }
}

/// {@template base_output_parser}
/// Class to parse the output of an LLM call.
/// {@endtemplate}
abstract class BaseOutputParser<LLMOutput extends Object,
        ParserOutput extends Object>
    extends BaseLLMOutputParser<LLMOutput, ParserOutput> {
  /// {@macro base_output_parser}
  const BaseOutputParser();

  /// Return the string type key uniquely identifying this class of parser
  String get type;

  @override
  Future<ParserOutput> parseResult(
    final List<LanguageModelGeneration<LLMOutput>> result,
  ) {
    return parse(result.first.outputAsString);
  }

  /// Parse the output of an LLM call.
  ///
  /// A method which takes in a string (assumed output of a language model)
  /// and parses it into some structure.
  ///
  /// [text] - LLM output to parse.
  Future<ParserOutput> parse(final String text);

  /// Optional method to parse the output of an LLM call with a prompt.
  ///
  /// The prompt is largely provided in the event the OutputParser wants to
  /// retry or fix the output in some way, and needs information from the
  /// prompt to do so.
  ///
  /// [text] - LLM output to parse.
  /// [prompt] - Prompt used to generate the output.
  Future<ParserOutput> parseWithPrompt(
    final String text,
    final PromptValue prompt,
  ) async {
    return parse(text);
  }

  /// Return a string describing the format of the LLM output.
  ///
  /// [options] - Options for formatting instructions.
  String getFormatInstructions([final FormatInstructionsOptions? options]);
}
