package fetch

import (
	"context"
	"errors"
	"testing"
)

type stubClient struct {
	result string
	err    error
}

func (s stubClient) Fetch(context.Context, string) (string, error) {
	return s.result, s.err
}

func TestFetchAllReturnsClientError(t *testing.T) {
	want := errors.New("fetch failed")
	_, got := FetchAll(context.Background(), stubClient{err: want}, []string{"/one"})
	if !errors.Is(got, want) {
		t.Fatalf("FetchAll error = %v; want %v", got, want)
	}
}
