/// extend this class to declare your queries
/// implement the key getter returning an unique id for the query
/// implement the fetch method returning data or errors
abstract class QueryModel {
  get key;

  Future fetch();
}
